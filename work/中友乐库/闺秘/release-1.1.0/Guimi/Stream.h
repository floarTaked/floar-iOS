#pragma once 

#ifdef __cplusplus
#include <cstring>

namespace zli
{
	typedef char C4[4];
	typedef char C2[2];
	typedef char C1[1];

	typedef const char CC4[4];
	typedef const char CC2[2];
	typedef const char CC1[1];

	typedef unsigned char UC4[4];
	typedef unsigned char UC2[2];
	typedef unsigned char UC1[1];

	typedef const unsigned char CUC4[4];
	typedef const unsigned char CUC2[2];
	typedef const unsigned char CUC1[1];

	typedef C4 * PC4;
	typedef C2 * PC2;
	typedef C1 * PC1;

	typedef CC4 * PCC4;
	typedef CC2 * PCC2;
	typedef CC1 * PCC1;

	typedef UC4 * PUC4;
	typedef UC2 * PUC2;
	typedef UC1 * PUC1;

	typedef CUC4 * PCUC4;
	typedef CUC2 * PCUC2;
	typedef CUC1 * PCUC1;

	/// Uint --> Char[N]
	inline void u32ToC4(uint_fast32_t i, PC4 pc4) {
		C4 & rc4 = *pc4;
		rc4[0] = static_cast<char>((i >> 24));
		rc4[1] = static_cast<char>((i >> 16));
		rc4[2] = static_cast<char>((i >> 8));
		rc4[3] = static_cast<char>((i));
	}

	inline void u32ToC4L(uint_fast32_t i, PC4 pc4) {
		C4 & rc4= *pc4;
		rc4[3] = static_cast<char>((i >> 24));
		rc4[2] = static_cast<char>((i >> 16));
		rc4[1] = static_cast<char>((i >> 8));
		rc4[0] = static_cast<char>((i));
	}

	inline void u16ToC2(uint_fast16_t i, PC2 pc2) {
		C2 & rc2 = *pc2;
		rc2[0] = static_cast<char>((i >> 8));
		rc2[1] = static_cast<char>((i));
	}

	inline void u16ToC2L(uint_fast16_t i, PC2 pc2) {
		C2 & rc2 = *pc2;
		rc2[1] = static_cast<char>((i >> 8));
		rc2[0] = static_cast<char>((i));
	}

	inline void u8ToC1(uint_fast8_t i, PC1 pc1) {
		C1 & rc1 = *pc1;
		rc1[0] = static_cast<char>((i));
	}

	inline void u8ToC1L(uint_fast8_t i, PC1 pc1) {
		C1 & rc1 = *pc1;
		rc1[0] = static_cast<char>((i));
	}

	/// Char[N] --> Uint
	inline uint_fast8_t c1ToU8(PCC1 pcc1) {
		CUC1 & rc1 = reinterpret_cast<CUC1&>(*pcc1);
		return static_cast<uint_fast8_t>(rc1[0]);
	}

	inline uint_fast8_t c1ToU8L(PCC1 pcc1) {
		CUC1 & rc1 = reinterpret_cast<CUC1&>(*pcc1);
		return static_cast<uint_fast8_t>(rc1[0]);
	}

	inline uint_fast16_t c2ToU16(PCC2 pcc2) {
		CUC2 & rc2 = reinterpret_cast<CUC2&>(*pcc2);
		return (static_cast<uint_fast16_t>(rc2[0]) << 8) + (static_cast<uint_fast16_t>(rc2[1]));
	}

	inline uint_fast16_t c2ToU16L(PCC2 pcc2) {
		CUC2 & rc2 = reinterpret_cast<CUC2&>(*pcc2);
		return (static_cast<uint_fast16_t>(rc2[1]) << 8) + (static_cast<uint_fast16_t>(rc2[0]));
	}

	inline uint_fast32_t c4ToU32(PCC4 pcc4) {
		CUC4 & rc4 = reinterpret_cast<CUC4&>(*pcc4);
		return (static_cast<uint_fast32_t>(rc4[0]) << 24) + (static_cast<uint_fast32_t>(rc4[1]) << 16) + (static_cast<uint_fast32_t>(rc4[2] << 8) + (static_cast<uint_fast32_t>(rc4[3]))); 
	}

	inline uint_fast32_t c4ToU32L(PCC4 pcc4) {
		CUC4 & rc4 = reinterpret_cast<CUC4&>(*pcc4);
		return ( static_cast<uint_fast32_t>(rc4[3]) << 24) + (static_cast<uint_fast32_t>(rc4[2]) << 16) + (static_cast<uint_fast32_t>(rc4[1] << 8) + (static_cast<uint_fast32_t>(rc4[0]))); 
	}

	struct StreamWriter
	{
		public:
			StreamWriter(void * p = NULL)
			{
				reset(p);
			}

			void w(char c) {
				*(curr++) = c;
			}

			void w1(uint_fast8_t u) {
				PC1 p = (PC1)curr; curr += 1;
				u8ToC1(u, p);
			}
			void w2(uint_fast16_t u) {
				PC2 p = (PC2)curr; curr += 2;
				u16ToC2(u, p);
			}
			void w4(uint_fast32_t u) {
				PC4 p = (PC4)curr; curr += 4;
				u32ToC4(u, p);
			}
			void w8(uint_fast64_t u) {
				uint_fast32_t h = u >> 32;
				uint_fast32_t l = u & 0xffffffff;
				w4(h);w4(l);
			}

			void w1L(uint_fast8_t u) {
				PC1 p = (PC1)curr; curr += 1;
				u8ToC1L(u, p);
			}
			void w2L(uint_fast16_t u) {
				PC2 p = (PC2)curr; curr += 2;
				u16ToC2L(u, p);
			}
			void w4L(uint_fast32_t u) {
				PC4 p = (PC4)curr; curr += 4;
				u32ToC4L(u, p);
			}
			void w8L(uint_fast64_t u) {
				uint_fast32_t h = u >> 32;
				uint_fast32_t l = u & 0xffffffff;
				w4L(l);w4L(h);
			}

			void w(const void * s, size_t len) {
				memcpy(curr, s, len);
				curr += len;
			}

			void wL(const void *s, size_t len) {
				const char * e = static_cast<const char*>(s) + len;
				while(e > s) {
					*(curr++) = *(--e);
				}
			}

			char * origin() const { return start; }
			char * pos() const { return curr; }
			size_t offset() const { return curr - start; }
			void reset() { curr = start; }
			void reset(void * s) { curr = start = static_cast<char*>(s); }
			void skip(size_t len) { curr += len; }

		private:
			char * start;
			char * curr;
	};


	struct StreamReader
	{
		public:
			StreamReader(const void * p = NULL) {
				reset(p); 
			}

			char r() {
				return *(curr++);
			}

			uint_fast8_t r1() {
				PC1 p = (PC1)curr; curr += 1;
				return c1ToU8(p);
			}
			uint_fast16_t r2() {
				PC2 p = (PC2)curr; curr += 2;
				return c2ToU16(p);
			}
			uint_fast32_t r4() {
				PC4 p = (PC4)curr; curr += 4;
				return c4ToU32(p);
			}
			uint_fast64_t r8() {
				uint_fast64_t h = static_cast<uint_fast64_t>(r4()) << 32;
				uint_fast64_t l = static_cast<uint_fast64_t>(r4());
				return h | l;
			}

			uint_fast8_t r1L() {
				PC1 p = (PC1)curr; curr += 1;
				return c1ToU8L(p);
			}
			uint_fast16_t r2L() {
				PC2 p = (PC2)curr; curr += 2;
				return c2ToU16L(p);
			}
			uint_fast32_t r4L() {
				PC4 p = (PC4)curr; curr += 4;
				return c4ToU32L(p);
			}
			uint_fast64_t r8L() {
				uint_fast64_t l = static_cast<uint_fast64_t>(r4L());
				uint_fast64_t h = static_cast<uint_fast64_t>(r4L()) << 32;
				return h | l;
			}

			void r(void * d, size_t len) {
				memcpy(d, curr, len);
				curr += len;
			}

			void rL(void * d_, size_t len) {
				char * d = static_cast<char*>(d_);
				const char * e = curr + len;
				while(e > curr) {
					*(d++) = *(--e);
				}
				curr += len;
			}

			const char * origin() const { return start; }
			const char * pos() const { return curr; }
			size_t offset() const { return curr - start; }
			void reset() { curr = start; }
			void reset(const void * s) { curr = start = static_cast<const char*>(s); }
			void skip(size_t len) { curr += len; }

		private:
			const char * start;
			const char * curr;
	};

}

#endif

