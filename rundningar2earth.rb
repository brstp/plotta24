# encoding: UTF-8

points = Hash.new

file = File.open(File.expand_path('punkter.csv'))
file.each do |line|
  attrs = line.split(",")
  wpt = attrs[0].to_s
  points[wpt] = Hash.new
  points[wpt]["lat"] = attrs[1].to_f
  points[wpt]["lng"] = attrs[2].to_f
end



output_string = %(<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2" xmlns:gx="http://www.google.com/kml/ext/2.2" xmlns:kml="http://www.opengis.net/kml/2.2" xmlns:atom="http://www.w3.org/2005/Atom">
<Document>
	<name>24-timmarssegling</name>
	<Folder>
		<name>Rutter</name>
		
)

file = File.open(File.expand_path('rundningar.csv'))
file.each do |line|
  attrs = line.split(",")
  attrs.each do |attr|
    attr.gsub!(/"/, '')
  end
  output_string << %(
  		<Placemark>
			<name>#{ attrs[4]} (#{ attrs[5]})</name>
			<description>Krets: #{attrs[0]}, Segling: #{attrs[1]}, Seglingsperiod: #{attrs[2]} Startpunkt:#{attrs[3]} #{ attrs[4]} (#{ attrs[5]}) </description>
      			<LineString>
				<tessellate>1</tessellate>
				<coordinates>
  )
  height = 0
  wpts = attrs[7..attrs.count]
  previous = attrs[6]
  wpts.each do |wpt|
    wpt = wpt.squeeze(" ").strip
    unless wpt.empty?
      output_string << %(#{points[previous]["lat"]},#{points[previous]["lng"]},#{height} #{points[wpt]["lat"]},#{points[wpt]["lng"]},#{height+1} )
      height = height + 1
      previous = wpt
    end
  end
  output_string << %(
  				</coordinates>
			</LineString>
		</Placemark>
    )
    
end

output_string << %(

	</Folder>
</Document>
</kml>

)

puts output_string
