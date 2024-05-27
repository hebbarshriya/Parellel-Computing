__kernel void deciToOct( __global int *A,__global int *B)
{
	// Get the index of the current work item
	int tid = get_global_id(0);
	
	// Do the operation
	int num = A[tid];
	int pow=1,rem,octal=0;
	
	while (num!= 0) 
	{
        rem = num % 8;
        octal += rem*pow;
        pow = pow * 10;
        num /= 8;
    }
	B[tid]=octal;
}