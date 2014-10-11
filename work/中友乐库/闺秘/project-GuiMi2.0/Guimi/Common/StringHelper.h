#pragma once

#ifdef __cplusplus
#include <string>

namespace zli
{
	std::string trim(const std::string & s);
	extern std::string hexShow(const void * buffer, size_t len);
	extern void hex2str(void * dst, const void * str, size_t len);
	extern std::string hex2str(const void * str, size_t len);
	extern std::string hex2str(const std::string & src);
	extern void str2hex(void * dst, const void * str, size_t len);
	extern std::string str2hex(const void * str, size_t len);
	extern std::string str2hex(const std::string & src);
	extern void reverse(void * str, size_t len);
}

	extern "C" void __zli__hex2str(void * dst, const void * str, size_t len);
	extern "C" void __zli__str2hex(void * dst, const void * str, size_t len);

#else
#include <stdlib.h>

	extern void __zli__hex2str(void * dst, const void * str, size_t len);
	extern void __zli__str2hex(void * dst, const void * str, size_t len);
	extern void __zli__reverse(char * str, size_t len);

#endif

