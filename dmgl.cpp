#include <iostream>
#include <cstdlib>
#include <cxxabi.h>

int main(int argc, char **argv)
{
	const char *name;
	for (int i = 1; i < argc; i++)
	{
		int status;
		name = argv[i];
		char *dmn = abi::__cxa_demangle(name, 0, 0, &status);
		if (status)
		{
			std::cerr << name << ": (Bad symbol)" << std::endl;
			continue;
		}
		std::cout << dmn << std::endl;
		std::free(dmn);
	}
	return 0;
}
