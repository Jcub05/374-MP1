// Jacob Badali 20290739
#include "cuda_runtime.h"
#include "device_launch_parameters.h"

#include <stdio.h>
#include <math.h>
#include <stdlib.h>

#define Threads_per_block 128

#define num_row (100) //Not sure what this size means, will find out later. wondering why it isn't like [][]...
#define num_col (100)

int  dM[num_row][num_col];
int  dN[num_row][num_col];
int  dP[num_row][num_col];

int  hM[num_row][num_col];
int  hN[num_row][num_col];
int  hP[num_row][num_col];

#define WIDTH = 100; //change this

int size = WIDTH * WIDTH * sizeof(float);



cudaError_t addWithCuda(int *c, const int *a, const int *b, unsigned int size);


//Multiplication kernel function
__global__ void mulKernel(int* P, int* M, int* N, int rows_and_cols) {
    int rows = blockIdx.y * blockDim.y + threadIdx.y;
    int cols = blockIdx.x * blockDim.x + threadIdx.x;

    float temp_sum = 0.0;

    if (row < rows_and_cols && cols < rows_and_cols) {
        
        for (int i = 0; i < rows_and_cols; i++) {
            tmpSum += P[rows * rows_and_cols + i] * M[i * rows_and_cols + cols];
        }
    }
    C[rows * rows_and_cols + cols] = temp_sum;
}

void matrixMultiplicationdefn(int* P, int* M, int* N, int rows_and_cols) {
    //Define the dimensions of blocks and grids
    dim3 blocksPerGrid(rows_and_cols); //1x1x1
    dim3 threadsPerBlock(1, 1); //100x1x1
}

int main()
{
    //Pointers to host and device memory
    int* h_pointer = 0;
    int* d_pointer = 0;

    int n =






        int matrix_size = 100;
    //fill host mem
    for (int i = 0; i < matrix_size; i++) {
        hN[i] = hM[i] = (float)sqrtf((float)i);
    }

    cudaMemcpyAsync(d_pointer, h_pointer, )
        kernel << <blocksPerGrid, threadsPerBlock, 0, 0 >> > ()

}
// Helper function for using CUDA to add vectors in parallel.
cudaError_t addWithCuda(int *c, const int *a, const int *b, unsigned int size)
{
    int *dev_a = 0;
    int *dev_b = 0;
    int *dev_c = 0;
    cudaError_t cudaStatus;

    // Choose which GPU to run on, change this on a multi-GPU system.
    cudaStatus = cudaSetDevice(0);
    if (cudaStatus != cudaSuccess) {
        fprintf(stderr, "cudaSetDevice failed!  Do you have a CUDA-capable GPU installed?");
        goto Error;
    }

    // Allocate GPU buffers for three vectors (two input, one output)    .
    cudaStatus = cudaMalloc((void**)&dev_c, size * sizeof(int));
    if (cudaStatus != cudaSuccess) {
        fprintf(stderr, "cudaMalloc failed!");
        goto Error;
    }

    cudaStatus = cudaMalloc((void**)&dev_a, size * sizeof(int));
    if (cudaStatus != cudaSuccess) {
        fprintf(stderr, "cudaMalloc failed!");
        goto Error;
    }

    cudaStatus = cudaMalloc((void**)&dev_b, size * sizeof(int));
    if (cudaStatus != cudaSuccess) {
        fprintf(stderr, "cudaMalloc failed!");
        goto Error;
    }

    // Copy input vectors from host memory to GPU buffers.
    cudaStatus = cudaMemcpy(dev_a, a, size * sizeof(int), cudaMemcpyHostToDevice);
    if (cudaStatus != cudaSuccess) {
        fprintf(stderr, "cudaMemcpy failed!");
        goto Error;
    }

    cudaStatus = cudaMemcpy(dev_b, b, size * sizeof(int), cudaMemcpyHostToDevice);
    if (cudaStatus != cudaSuccess) {
        fprintf(stderr, "cudaMemcpy failed!");
        goto Error;
    }

    // Launch a kernel on the GPU with one thread for each element.
    addKernel<<<1, size>>>(dev_c, dev_a, dev_b);

    // Check for any errors launching the kernel
    cudaStatus = cudaGetLastError();
    if (cudaStatus != cudaSuccess) {
        fprintf(stderr, "addKernel launch failed: %s\n", cudaGetErrorString(cudaStatus));
        goto Error;
    }
    
    // cudaDeviceSynchronize waits for the kernel to finish, and returns
    // any errors encountered during the launch.
    cudaStatus = cudaDeviceSynchronize();
    if (cudaStatus != cudaSuccess) {
        fprintf(stderr, "cudaDeviceSynchronize returned error code %d after launching addKernel!\n", cudaStatus);
        goto Error;
    }

    // Copy output vector from GPU buffer to host memory.
    cudaStatus = cudaMemcpy(c, dev_c, size * sizeof(int), cudaMemcpyDeviceToHost);
    if (cudaStatus != cudaSuccess) {
        fprintf(stderr, "cudaMemcpy failed!");
        goto Error;
    }

Error:
    cudaFree(dev_c);
    cudaFree(dev_a);
    cudaFree(dev_b);
    
    return cudaStatus;
}
