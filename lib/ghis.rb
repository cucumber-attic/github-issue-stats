require 'json'
require 'time'

class Issues
  def initialize(issues_path)
    @issues = JSON.parse(IO.read(issues_path)).map{|hash| Issue.new(hash)}
  end

  def timeline
    start = timestamps[0]
    finish = timestamps[-1]

    timeline = []
    timestamps.each do |timestamp|
      status = {unborn: 0, open: 0, closed: 0}
      @issues.each do |issue|
        status[issue.status(timestamp)] += 1
      end

      entry = [timestamp, status.dup]
      timeline << entry

      time_where_total_count_like_closed = nil
      timeline.each do |past|
        total_count = past[1][:open] +  past[1][:closed]
        if total_count >= status[:closed]
          time_where_total_count_like_closed = past[0]
          break
        end
      end
      lead_time = (timestamp-time_where_total_count_like_closed)
      entry[1][:lead_time] = lead_time
    end

    timeline
  end

  def timestamps
    @timestamps ||= @issues.map {|i| [i.created_at, i.closed_at]}.flatten.compact.sort
  end
end

class Issue
  def initialize(hash)
    @hash = hash
  end

  def created_at
    @created_at ||= Time.parse(@hash['created_at'])
  end

  def closed_at
    @closed_at ||= @hash['closed_at'].nil? ? nil : Time.parse(@hash['closed_at'])
  end

  def status(timestamp)
    return :unborn if timestamp < created_at
    return :closed if closed_at && (closed_at < timestamp)
    return :open
  end
end
