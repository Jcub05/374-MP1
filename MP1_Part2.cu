// Jacob Badali 20290739
#include "cuda_runtime.h"
#include "device_launch_parameters.h"

#include <stdio.h>
#include <math.h>
#include <stdlib.h>

#define Threads_per_block 128

#define num_row (100) //Not sure what this size means, will find out later. wondering why it isn't like [][]...
#define num_col (100)

float  d_M[num_row][num_col];
float  d_N[num_row][num_col];
float  d_P[num_row][num_col];

float  h_M[num_row][num_col];
float  h_N[num_row][num_col];
float  h_P[num_row][num_col];

#define WIDTH = 100; //change this
#define BLOCK_WIDTH = 32;

int size = WIDTH * WIDTH * sizeof(float);



cudaError_t addWithCuda(int *c, const int *a, const int *b, unsigned int size);


//Multiplication kernel function
__global__ void mulKernel(int* M, int* N, int* P, int size) {
    int rows = blockIdx.y * blockDim.y + threadIdx.y;
    int cols = blockIdx.x * blockDim.x + threadIdx.x;


    if (rows < size && cols < size) {
        float temp_sum = 0.0;
        for (int i = 0; i < size; i++) {
            temp_sum += M[rows * size + i] * N[i * size + cols];
        }
        C[rows * size + cols] = temp_sum;
    }
}


int main()
{
    //Pointers to host and device memory
    int* h_pointer = 0;
    int* d_pointer = 0;

    int NumBlocks = WIDTH / BLOCK_WIDTH;
    if (WIDTH % BLOCK_WIDTH) NumBlocks++;

    dim3 dimGrid(NumBlocks, NumBlocks);
    dim3 dimBlock(BLOCK_WIDTH, BLOCK_WIDTH);

    //Allocate appropriate memory size for each array
    cudaMalloc((void**)&d_M, size*sizeof(float);
    cudaMalloc((void**)&d_N, size*sizeof(float);
    cudaMalloc((void**)&d_P, size*sizeof(float);

    







    //fill host matrices
    for (int i = 0; i < num_row; i++) {
        for (int j = 0; j < num_col; j++) {
            h_M[i][j] = ((float)rand() / RAND_MAX) * 100.0; //fill with rand values from 0-100
            h_N[i][j] = ((float)rand() / RAND_MAX) * 100.0;
        }
    }

    //Host matrix multiplication
    for (int i = 0; i < n; i++) {
        for (int j = 0; j < n; j++) {
            h_P[i][j] = 0;
            for (int k = 0; k < n; k++) {
                h_P[i][j] += h_M[i][k] * h_N[k][j];
            }
        }
    }

    //fill device matrices

    //Cpy to dev, timer

    //Device Matrix multiplication
    mulKernel << <dimBlock, dimGrid, 0, 0 >> > (d_M, d_N, d_P, size);
    
    //Cpy to dev, timer

    cudaFree(d_M);
    cudaFree(d_N);
    cudaFree(d_P);
}
