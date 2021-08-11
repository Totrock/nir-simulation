import numpy as np
import SimpleITK as sitk
import data_preparation


def segment():
    """
    WIP to combine the segmentations
    :return:
    """
    enam = sitk.ReadImage("P30A-C0005383_bin-mask.mhd")
    dent = sitk.ReadImage("P30A-C0005383_bin-mask.mhd")

    img_enam = sitk.GetArrayFromImage(enam)
    img_dent = sitk.GetArrayFromImage(dent)

    img_combined = img_enam + img_dent * 2

    # img_combined = np.where(img_combined > 2, 1, img_combined)
    # img = sitk.GetImageFromArray(img_combined)
    #
    # air_img = sitk.ConnectedThreshold(img, seedList=[(0, 0, 0)], lower=0, upper=0)
    #
    # air = sitk.GetArrayFromImage(air_img)
    #
    # img_combined = img_combined + 3*air
    #
    # img_combined = np.where(img_combined == 0, 4, img_combined)
    # img_combined = np.where(img_combined == 3, 0, img_combined)
    # img_combined = np.where(img_combined == 4, 3, img_combined)

    img = sitk.GetImageFromArray(img_combined)

    sitk.WriteImage(img, "P30A-C0005383.mhd")


data_preparation.create_downsampled_series("P02A-C0005280.mhd")
