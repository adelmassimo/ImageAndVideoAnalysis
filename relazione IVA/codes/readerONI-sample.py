import numpy as np
from openni import openni2 
import png


path = "/Volumes/Volume/Top-view-TVPR/"
prefix = "g0"

for i in range(1, 23):
	filename = prefix + str(i)
	openni2.initialize()
	dev = openni2.Device(path+filename+".oni")
	print dev.get_device_info()

	depth_stream = dev.create_depth_stream()
	total_frames = depth_stream.get_number_of_frames()
	print "total frames: "+str(total_frames)

	for i in range(total_frames):
		depth_stream.start()
		frame = depth_stream.read_frame()
		depth_stream.stop()
		frame_data = frame.get_buffer_as_uint16()
		save_frame(frame_data, i)

	openni2.unload()