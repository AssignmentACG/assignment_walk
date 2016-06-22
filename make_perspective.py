# -*- encoding: utf-8 -*-
# Author: Epix
import cv2
import numpy as np


def make_perspective_pics(input_filename, output_filename_prefix, input_points):
    near_top_left, far_top_left, far_bottom_right, near_bottom_right = input_points
    near_bottom_left = [near_top_left[0], near_bottom_right[1]]
    near_top_right = [near_bottom_right[0], near_top_left[1]]
    far_bottom_left = [far_top_left[0], far_bottom_right[1]]
    far_top_right = [far_bottom_right[0], far_top_left[1]]
    img = cv2.imread(input_filename)
    rows, cols, ch = img.shape
    width = 300
    height = 300
    depth = 3000
    # left
    pts1 = np.float32([near_top_left, far_top_left, near_bottom_left, far_bottom_left])
    pts2 = np.float32([[0, 0], [depth, 0], [0, height], [depth, height]])
    make_perspective(img, output_filename_prefix + '_l.jpg', pts1, pts2, depth, height)
    # right
    pts1 = np.float32([far_top_right, near_top_right, far_bottom_right, near_bottom_right])
    pts2 = np.float32([[0, 0], [depth, 0], [0, height], [depth, height]])
    make_perspective(img, output_filename_prefix + '_r.jpg', pts1, pts2, depth, height)
    # top
    pts1 = np.float32([near_top_left, near_top_right, far_top_left, far_top_right])
    pts2 = np.float32([[0, depth], [width, depth], [0, 0], [width, 0]])
    make_perspective(img, output_filename_prefix + '_t.jpg', pts1, pts2, width, depth)
    # bottom
    pts1 = np.float32([near_bottom_left, near_bottom_right, far_bottom_left, far_bottom_right])
    pts2 = np.float32([[0, 0], [width, 0], [0, depth], [width, depth]])
    make_perspective(img, output_filename_prefix + '_b.jpg', pts1, pts2, width, depth)
    # center
    pts1 = np.float32([far_top_left, far_top_right, far_bottom_left, far_bottom_right])
    pts2 = np.float32([[0, 0], [width, 0], [0, height], [width, height]])
    make_perspective(img, output_filename_prefix + '_c.jpg', pts1, pts2, width, height)


def make_perspective(input_image, output_filename, source_points, target_points, target_width, target_height):
    M = cv2.getPerspectiveTransform(source_points, target_points)
    dst = cv2.warpPerspective(input_image, M, (target_width, target_height))
    cv2.imwrite(output_filename, dst)


def make_perspective_pics_w_800_600(input_filename, output_filename_prefix, input_points):
    img = cv2.imread(input_filename)
    r_height, r_width, ch = img.shape
    original_points = []
    for point_index in range(1, 5):
        x, y = input_points[str(point_index)]
        original_points.append([int((x + 400) / 800*r_width), int((y + 300) / 600*r_height)])

    make_perspective_pics(input_filename, output_filename_prefix, original_points)


if __name__ == '__main__':
    make_perspective_pics('IMG_20160622_135529.jpg', '', [[562, 122], [1429, 632], [1557, 768], [1773, 1493]])
