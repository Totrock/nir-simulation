import pymcx as mcx
import json
import random
import SimpleITK as sitk
import numpy as np
import jdata

# The newer version of the binary doesn't work
VERY_SMALL_NON_ZERO_VALUE = 10 ** -20
mcxbin = "../../MCXStudiov2020/MCXSuite/mcx/bin/mcx"

bin_filename = "down128.bin"
mhd_filename = "../down128.mhd"


# inspired from pymcx mcx_writevolbin
def better_write_vol_bin(vol, filename, used_type=np.byte):
    f = open(filename, 'wb')
    byte_array = np.array(vol, used_type)
    f.write(byte_array)
    f.close()


def read_mhd(filename):
    img = sitk.ReadImage(filename)
    dimension = list(img.GetSize())
    x = dimension[0]
    y = dimension[1]
    z = dimension[2]
    vol = sitk.GetArrayFromImage(img)
    vol = np.where(vol == 0, 1, vol)

    #
    #vol = np.where(vol == 1, 0, vol)
    #
    vol = vol.astype(np.byte)
    return vol, x, y, z


def zero_padding(vol):
    vol[:, :, 0] = 0
    vol[:, 0, :] = 0
    vol[0, :, :] = 0
    vol[:, :, vol.shape[2] - 1] = 0
    vol[:, vol.shape[1] - 1, :] = 0
    vol[vol.shape[0] - 1, :, :] = 0
    return vol


def create_config(x, y, z):
    cfg = mcx.create()  # create a default config dictionary

    cfg["Domain"]["VolumeFile"] = bin_filename
    cfg["Domain"]["MediaFormat"] = "byte"
    cfg["Domain"]["Dim"] = [x, y, z]
    cfg["Domain"]["OriginType"] = 1
    cfg["Domain"]["LengthUnit"] = (1024 / x) * 0.02
    cfg["Domain"]["Media"] = [{'mua': 0.0, 'mus': 0.0, 'g': 1.0, 'n': 1.0},
                              {'mua': 0.0, 'mus': 0.0, 'g': 1.0, 'n': 1.0},
                              {'mua': 0.1, 'mus': 2.867, 'g': 0.99, 'n': 1.63},
                              {'mua': 0.35, 'mus': 22.193, 'g': 0.83, 'n': 1.49},
                              {'mua': 2.8, 'mus': 0.0, 'g': 1.0, 'n': 1.333}]

    cfg["Forward"]["Dt"] = 5e-09
    cfg["Forward"]["T0"] = 0.0
    cfg["Forward"]["T1"] = 5e-09

    cfg["Session"]["Photons"] = 1e7
    cfg["Session"]["RNGSeed"] = random.randint(0, 999999999)
    cfg["Session"]["ID"] = "cfg_from_python"
    cfg["Session"]["DoAutoThread"] = 1

    cfg["Optode"]["Source"]["Dir"] = [0.0, 1, 0]
    cfg["Optode"]["Source"]["Param1"] = [0.0, 0.0, 0.0, 0.0]
    cfg["Optode"]["Source"]["Param2"] = [0.0, 0.0, 0.0, 0.0]
    cfg["Optode"]["Source"]["Pos"] = [x / 2, 1, z * 3 / 4]
    cfg["Optode"]["Source"]["Type"] = "pencil"

    cfg["Optode"]["Detector"] = [{"Pos": [x / 2, y / 2, 0.0], "R": 5.0}]

    # del cfg["Optode"]["Detector"]
    del cfg["Shapes"]

    flags = ""
    # flags += "-a 1 "
    # flags += "--outputformat jnii " # tx3 jnii
    flags += "--saveexit 1 "
    flags += "--saveref 1 "
    flags += "--savedetflag 127 "
    # flags += "--bc aaaaaa111111 "
    # flags += "--dumpjson"
    return cfg, flags


def interpret_output(data):
    fluence_and_dref = data[1]
    # diffuse reflectance has a negative sign: https://github.com/fangq/mcx#volumetric-output
    fluence = np.log(np.where(fluence_and_dref <= 0, VERY_SMALL_NON_ZERO_VALUE, fluence_and_dref))
    fluence = np.where(fluence < 0, 0, fluence)

    dref = np.where(fluence_and_dref < 0, -fluence_and_dref, 0)
    dref = np.where(dref == 0, VERY_SMALL_NON_ZERO_VALUE, dref)
    dref = np.log(dref)
    dref = np.where(dref < 0, 0, dref)

    dref_img = sitk.GetImageFromArray(dref)
    sitk.WriteImage(dref_img, "dref.mhd")

    fluence_img = sitk.GetImageFromArray(fluence)
    sitk.WriteImage(fluence_img, "fluence.mhd")


def run_mcx():
    volume, x, y, z = read_mhd(mhd_filename)
    volume = zero_padding(volume)
    better_write_vol_bin(volume, bin_filename)
    cfg, flags = create_config(x, y, z)
    return mcx.run(cfg, flag=flags, mcxbin=mcxbin)


mch_mc2 = run_mcx()
interpret_output(mch_mc2)


