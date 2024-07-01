
import numpy as np
import scipy.io

class Image():
    def __init__(self,path,cam,mov):
        
        self.all_frames = np.hstack((scipy.io.loadmat(f'{path}/2d_data/location_cam{cam}_mov{mov}.mat')['m'],scipy.io.loadmat(f'{path}/2d_data/value_cam{cam}_mov{mov}.mat')['m']))
        

    def get_frame(self,frame_num):
        """get frame from all frames

        Args:
            frame_num (int): number of frame in sparse file
        """
        self.frame = self.all_frames[self.all_frames[:,2] == frame_num,:] 


    def gen_image(self,image_size = [800,1280]):
        """generate image from frame indices

        Args:
            image_size (list, optional): size of original image. Defaults to [800,1280].

        Returns:
            np array: image
        """

        self.image = np.zeros((image_size))
        self.image[self.frame[:,1],self.frame[:,0]] = self.frame[:,3]
        return self.image
    
    def crop_size(self):
        """calculate the size of crop (includes only the object)
        """
        self.crop_pixels = [np.min(self.frame[:,0]),np.max(self.frame[:,0]),np.min(self.frame[:,1]),np.max(self.frame[:,1])] 
        
    

    def load_frame_and_size_of_crop(self,frame_num):
        """load a frame and get the size needed to crop 

        Args:
            frame_num (int): frame number

        Returns:
            list: the pixels of the crop's bounding box
        """
        self.get_frame(frame_num)
        self.gen_image()
        self.crop_size()
        return self.crop_pixels
    

    def crop_image(self,delta_x_y_crop,dy_crop = 0,dx_crop = 0):
        """crop image from the top right pixel (calculated in crop_size) to delta_x_y_crop - size of bounding box in x and y

        Args:
            delta_x_y_crop (list): size of bounding box in x and y
            dy_crop (int, optional): add pixels to y axis of the bounding box. Defaults to 0.
            dx_crop (int, optional): add pixels to x axis of the bounding box. Defaults to 0.

        Returns:
            np array: croped image
        """
        self.crop_bot_left = [np.min(self.frame[:,0]) - dx_crop,np.min(self.frame[:,1]) + dy_crop + delta_x_y_crop[1]]
        return self.image[np.min(self.frame[:,1]) - dy_crop:np.min(self.frame[:,1])+ dy_crop + delta_x_y_crop[1],np.min(self.frame[:,0]) - dx_crop:np.min(self.frame[:,0]) + delta_x_y_crop[0] + dx_crop]

