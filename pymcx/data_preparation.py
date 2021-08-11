import numpy as np
import SimpleITK as sitk


def downsample_patient(patient_ct, resize_factor):
    """
    downsamples a CT image
    from https://stackoverflow.com/a/63120034
    with the comment
    :param patient_ct:  filename of the CT-Image
    :param resize_factor: Image will be 1/resize_factor after transformation
    :return:
    """
    original_ct = sitk.ReadImage(patient_ct, sitk.sitkInt32)
    dimension = original_ct.GetDimension()
    reference_physical_size = np.zeros(original_ct.GetDimension())
    reference_physical_size[:] = [(sz - 1) * spc if sz * spc > mx else mx for sz, spc, mx in
                                  zip(original_ct.GetSize(), original_ct.GetSpacing(), reference_physical_size)]

    reference_origin = original_ct.GetOrigin()
    reference_direction = original_ct.GetDirection()

    reference_size = [round(sz / resize_factor) for sz in original_ct.GetSize()]
    reference_spacing = [phys_sz / (sz - 1) for sz, phys_sz in zip(reference_size, reference_physical_size)]

    reference_image = sitk.Image(reference_size, original_ct.GetPixelIDValue())
    reference_image.SetOrigin(reference_origin)
    reference_image.SetSpacing(reference_spacing)
    reference_image.SetDirection(reference_direction)

    reference_center = np.array(
        reference_image.TransformContinuousIndexToPhysicalPoint(np.array(reference_image.GetSize()) / 2.0))

    transform = sitk.AffineTransform(dimension)
    transform.SetMatrix(original_ct.GetDirection())

    transform.SetTranslation(np.array(original_ct.GetOrigin()) - reference_origin)

    centering_transform = sitk.TranslationTransform(dimension)
    img_center = np.array(original_ct.TransformContinuousIndexToPhysicalPoint(np.array(original_ct.GetSize()) / 2.0))
    centering_transform.SetOffset(np.array(transform.GetInverse().TransformPoint(img_center) - reference_center))
    centered_transform = sitk.CompositeTransform(transform)
    centered_transform.AddTransform(centering_transform)

    # sitk.Show(sitk.Resample(original_ct, reference_image, centered_transform, sitk.sitkLinear, 0.0))

    return sitk.Resample(original_ct, reference_image, centered_transform, sitk.sitkNearestNeighbor, 0.0)


def create_downsampled_series(filename):
    for x in range(1, 5):
        image_down = downsample_patient(filename, 2 ** x)
        sitk.WriteImage(image_down, add_x_at_end_of_filename(filename, "_" + str(2 ** x)))


def add_1_to_image(filename):
    tooth = sitk.ReadImage(filename)
    arr = sitk.GetArrayFromImage(tooth)
    tooth = sitk.GetImageFromArray(arr + 1)
    sitk.WriteImage(tooth, add_x_at_end_of_filename(filename))


def add_x_at_end_of_filename(filename, x="_1"):
    filename = filename.split(".")
    filename[len(filename) - 2] += x
    return ".".join(filename)
