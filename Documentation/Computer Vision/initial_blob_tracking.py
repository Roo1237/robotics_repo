import SimpleCV
import os
import sys
sys.path.append(os.environ['HOME'] + '/robotics_repo/Documentation/Computer Vision/infoscimechatronics')
import cvutils
import time
import serial

ser = serial.Serial('/dev/serial/by-id/usb-Arduino__www.arduino.cc__0043_85431303736351D070E0-if00')

camera = SimpleCV.Camera(0, {"width":960,"height":540})
os.system(os.environ['HOME'] + '/robotics_repo/Projects/2017/SoccerBots/uvcdynctrl-settings.tcl')

lab_grey_sample = cvutils.calibrate_white_balance(camera)
lab_goal_blue = cvutils.calibrate_colour_match(camera, lab_grey_sample)

speed = 0
global current_angle
current_angle = 0
prev_error = 0
integral = 0
derivative = 0

times = []

def average(numbers):
	x = 0
	for num in numbers:
		x += num
	x = float(x) / len(numbers)
	return x

def x_coordinate_to_angle(coord):
	return coord*35.543

def plant(control): #control input from -1...1 so -90...90 deg / sec
	current_angle += speed
	speed = control * 90
	return current_angle

def servo(target_angle, ser):
	target_angle += 90
	ser.write('?')
	current_angle = int(ser.readline().strip())
	angle_dif = target_angle - current_angle
	sys.stderr.write(str(current_angle))
	sys.stderr.write(str(angle_dif))
	for i in range(abs(int(angle_dif))):
		if angle_dif > 0:
			ser.write('+')
		if angle_dif < 0:
			ser.write('-')

def control(target):
	kp = 1
	ki = 1
	kd = 1
	error = target - current_angle
	integral += error
	derivative = error - prev_error
	prev_error = error
	control = kp * error + ki * integral + kd * derivative
	sys.stderr.write(control)
	sys.stderr.write(error * kp)
	sys.stderr.write(integral * ki)
	sys.stderr.write(derivative * kd)
	sys.stderr.write(plant(control))
	return plant(control)

while True:
	start_time = time.clock()
	image = cvutils.wb(camera.getImage().scale(0.25), lab_grey_sample)
	v,s,h = image.toHSV().splitChannels()
	hue_match = h.colorDistance((lab_goal_blue[0][0],lab_goal_blue[0][0],lab_goal_blue[0][0])).binarize(lab_goal_blue[0][1]*3)
	sat_match = s.colorDistance((lab_goal_blue[1][0],lab_goal_blue[1][0],lab_goal_blue[1][0])).binarize(lab_goal_blue[1][1]*3)
	matched = ((hue_match / 16) * (sat_match / 16))
	matched.show()
	blobs = matched.findBlobs(100, 1)
	if blobs is not None:
		blob_size = blobs[-1].area()
		image_size = image.area()
		#print blob_size / image_size
		if blob_size / image_size < 0.0075:
			print "Blobs too small!"
		else:
			(x,y) = blobs[-1].centroid()
			image.dl().line((x,0), (x,image.height), (255,0,0), antialias=False)
			image.dl().line((0,y), (image.width,y), (0,255,0), antialias=False)
			image.show()
			#print float(x) / image.width
			converted_coord = float(x) / image.width
			converted_coord = x_coordinate_to_angle(converted_coord*2-1)
			#print converted_coord
			servo(converted_coord, ser)
	else:
		print "No blobs found!"
	end_time = time.clock()
	elapsed_time = end_time - start_time
	#times.append(elapsed_time)
	#frame_rate = 1 / average(times)
	#image.drawText(('Frame rate:' + str(frame_rate)), 0, 0)
	#image.show()
