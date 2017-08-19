require 'ghis'

describe Issues do
  let(:issues) { Issues.new(File.dirname(__FILE__) + '/page-10.json') }

  it "calculates open tickets by day" do
    timeline = issues.timeline[0...5]

    output = timeline.map do |t|
      open = t[1][:open]
      closed = t[1][:closed]
      lead_time_days = t[1][:lead_time] / (3600 * 24)
      [t[0].iso8601, closed, open, "%.1f" % lead_time_days]
    end
    expect(output).to eq([
      ["2011-05-28T15:51:57Z", 0, 1, '0.0'],
      ["2011-05-28T16:03:47Z", 0, 2, '0.0'],
      ["2011-05-28T22:12:08Z", 0, 2, '0.3'],
      ["2011-05-29T20:34:45Z", 1, 2, '1.2'],
      ["2011-06-01T19:37:03Z", 1, 3, '4.2']
    ])
  end
end
