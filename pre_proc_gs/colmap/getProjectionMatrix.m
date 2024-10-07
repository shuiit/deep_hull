function P = getProjectionMatrix(znear, zfar, fovX, fovY)

    tanHalfFovY = tan(fovY / 2);
    tanHalfFovX = tan(fovX / 2);

    top = tanHalfFovY * znear;
    bottom = -top;
    right = tanHalfFovX * znear;
    left = -right;

    P = zeros(4, 4);

    z_sign = 1.0;

    P(1, 1) = 2.0 * znear / (right - left);
    P(2, 2) = 2.0 * znear / (top - bottom);
    P(1, 3) = (right + left) / (right - left);
    P(2, 3) = (top + bottom) / (top - bottom);
    P(3, 3) = z_sign;
    P(3, 4) = z_sign * zfar / (zfar - znear);
    P(4, 4) = -(zfar * znear) / (zfar - znear);

end
