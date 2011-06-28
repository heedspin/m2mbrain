require 'csv'
require 'time'

class Job
  Identifier = Struct.new(:jobno, :partno, :revision)
  Station = Struct.new(:name, :due_date1, :due_date2)
  attr_accessor :id, :quantity, :due_date, :stations
  def initialize(id, quantity, due_date)
    @id = id
    @quantity = quantity
    @due_date = due_date
    @stations = []
  end
  
  def to_s
    "Job #{self.id.jobno}, #{self.id.partno}, #{self.id.revision} quantity #{self.quantity} due #{self.due_date}"
  end
end

class MasterTrackingToSql
  def initialize
    @jobs = {}
  end

  def run
    CSV.open('MasterTrackingReport.CSV', 'r') do |row|
      jobno, partno, revision, quantity, due_date, sequence, station_name, station_date1, station_date2 = row  
      partno.strip!
      station_name.strip!
      revision.strip!
      quantity = quantity.to_i
      due_date = Time.parse(due_date)
      jobid = Job::Identifier.new(jobno, partno, revision)
      job = @jobs[jobid] ||= Job.new(jobid, quantity, due_date)
      job.stations.push Job::Station.new(station_name, station_date1, station_date2)
    end
    
    @jobs.values.each do |job|
      p "#{job} stations: " + job.stations.map(&:name).join(', ')
    end
  end
end

MasterTrackingToSql.new.run
