#include <stdio.h>
void main()
{
#ifdef INC
	printf("INC\n");
#else
	printf("test\n");
#endif

}
