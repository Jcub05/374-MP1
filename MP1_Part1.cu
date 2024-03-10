#include <cuda_runtime.h>
#include <stdio.h>

// Helper function to convert compute capability to the number of cores
int ConvertSMVer2Cores(int major, int minor) {
    // Refer to NVIDIA CUDA Programming Guide for the compute capability to cores conversion
    // This is a simplified version and may not cover all cases
    int cores;

    switch ((major << 4) + minor) {
    case 0x10:
        cores = 8;
        break;
    case 0x11:
    case 0x12:
        cores = 8;
        break;
    case 0x13:
        cores = 32;
        break;
    case 0x20:
        cores = 32;
        break;
    default:
        cores = 0;
        break;
    }

    return cores;
}


int main() {
    // CUDA initialization code (if needed)
    cudaSetDevice(0); // Set the device to GPU 0 (or the appropriate GPU index)

    int num_devices;
    cudaGetDeviceCount(&num_devices);

    if (num_devices == 0) {
        fprintf(stderr, "No CUDA devices found.\n");
        return 1;
    }

    for (int device_id = 0; device_id < num_devices; ++device_id) {
        cudaDeviceProp device_prop;
        cudaError_t cuda_status = cudaGetDeviceProperties(&device_prop, device_id);

        if (cuda_status != cudaSuccess) {
            fprintf(stderr, "Error: cudaGetDeviceProperties failed with error code %d\n", cuda_status);
            return 1;
        }

        printf("Device %d Information:\n", device_id);
        printf("Name: %s\n", device_prop.name);
        printf("Compute Capability: %d.%d\n", device_prop.major, device_prop.minor);
        printf("Clock Rate: %d kHz\n", device_prop.clockRate);
        printf("Number of SM (Streaming Multiprocessors): %d\n", device_prop.multiProcessorCount);
        printf("Number of Cores per SM: %d\n", ConvertSMVer2Cores(device_prop.major, device_prop.minor) * device_prop.multiProcessorCount);
        printf("Warp Size: %d\n", device_prop.warpSize);
        printf("Global Memory Size: %zu bytes\n", device_prop.totalGlobalMem);
        printf("Constant Memory Size: %zu bytes\n", device_prop.totalConstMem);
        printf("Shared Memory Size per Block: %zu bytes\n", device_prop.sharedMemPerBlock);
        printf("Registers per Block: %d\n", device_prop.regsPerBlock);
        printf("Max Threads per Block: %d\n", device_prop.maxThreadsPerBlock);
        printf("Max Size of Each Dimension of a Block: (%d, %d, %d)\n",
            device_prop.maxThreadsDim[0], device_prop.maxThreadsDim[1], device_prop.maxThreadsDim[2]);
        printf("Max Size of Each Dimension of a Grid: (%d, %d, %d)\n",
            device_prop.maxGridSize[0], device_prop.maxGridSize[1], device_prop.maxGridSize[2]);

        // Additional analysis or discussions can be included here

        printf("\n");
    }

    // Other CUDA-related code

    return 0;
}

