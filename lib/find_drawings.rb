

Part = Struct.new(:fpartno, :frev, :fdrawno, :drawing_paths)

def get_path(path)
  '\\\\sol\\Drawings\\DRAWINGS' + path.gsub('./','\\').gsub('/','\\')
end

def main
  parts = []
  File.open('catalog_drawing_numbers.csv') do |input|
    # ignore first line
    input.gets
    while line = input.gets
      fpartno, frev, fdrawno = line.split(',')
      parts.push Part.new(fpartno, frev, fdrawno.strip, [])
    end
  end

  files = []
  File.open('find.txt') do |input|
    while line = input.gets
      files.push line.strip
    end
  end

  puts "Read #{parts.size} parts and #{files.size} lines"

  update_sql = []
  no_drawings = []
  too_many = []
  parts.each do |part|
    if !part.fdrawno.nil? and (part.fdrawno.size > 0)
      part.drawing_paths = files.select { |f| f.include?(part.fdrawno) }
    end
    if part.drawing_paths.size == 0
      no_drawings.push part
    elsif part.drawing_paths.size == 1
      sets = []
      for n in 1..(part.drawing_paths.size)
        sets.push "fccadfile#{n} = '#{get_path(part.drawing_paths[n-1])}'"
      end
      update_sql.push "update inmast set #{sets.join(', ')} where fpartno='#{part.fpartno}' and frev='#{part.frev}' and fdrawno='#{part.fdrawno}'"
    else
      too_many.push part
    end
  end

  puts "Writing #{update_sql.size} updates, #{no_drawings.size} no drawings, #{too_many.size} too many"

  File.open('assign_drawings.sql', 'w+') do |output|
    output.write update_sql.join(";\n")
  end

  File.open('no_drawings.txt', 'w+') do |output|
    output.write no_drawings.map { |p| "#{p.fpartno}, #{p.frev}, #{p.fdrawno}" }.join("\n")
  end

  File.open('too_many_drawings.txt', 'w+') do |output|
    too_many.each do |p|
      output.puts "#{p.fpartno}, #{p.frev}, #{p.fdrawno}\n\t" + p.drawing_paths.join("\n\t")
    end
  end

end

main
