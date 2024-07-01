
import numpy as np

class Camera():
    def __init__(self,path,camera_number):
        camera_txt = np.genfromtxt(f'{path}/camera/camera{camera_number}_KRT.txt', delimiter=",")
        self.k_intrinsic = camera_txt[0:3]
        self.r_rotation = camera_txt[3:6]
        self.t_translation = camera_txt[6:7]
        self.camera_name = f'cam{camera_number}'
        self.gen_camera_matrix(self.k_intrinsic)

        


    def camera_calibration_crop(self,crop_pixels):
        """updates the intrinsic K matrix for croped images

        Args:
            crop_pixels (np array): loaction of left bottom pixel (we need the bottom because we flip it) [x,y]
        """
        self.k_intrinsic_croped = self.k_intrinsic.copy()
        self.k_intrinsic_croped[0,2] = self.k_intrinsic[0,2]  - crop_pixels[0]
        self.k_intrinsic_croped[1,2] = self.k_intrinsic[1,2] - (800 - crop_pixels[1])
        self.homo_mat = np.eye(4)
        self.homo_mat[:3,:3] = self.k_intrinsic_croped
        self.gen_camera_matrix(self.k_intrinsic_croped)
        

    def gen_camera_matrix(self,k):
        """generate the camera matrix [K[R|-T]]
        """
        kr = np.matmul(k,self.r_rotation)
        kt = np.matmul(k,self.t_translation.T)
        self.cam_matrix = np.hstack((kr,-kt))
        self.cam_matrix = self.cam_matrix/self.cam_matrix[2,3]

    
    def project_on_cam(self,points):
        """project 3d points on 2d image

        Args:
            points (np array): 3d points in camera axes
            cam_matrix (np array): camera calibration matrix [K[R|T]]

        Returns:
            pixels (x/u,y/v): _description_
        """

        points_homo = np.hstack((points,np.ones((1,points.shape[0])).T))
        points_2d = np.dot(self.cam_matrix,points_homo.T)
        points_2d = (points_2d[:-1, :] / points_2d[-1, :]).T
        return points_2d

