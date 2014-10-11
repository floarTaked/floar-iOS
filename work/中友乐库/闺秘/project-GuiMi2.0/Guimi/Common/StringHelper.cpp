#include "StringHelper.h"
#include "Stream.h"

static const char ctbl[256] =
{
  0,0,0,0,0,0,0,0    ,0,0,0,0,0,0,0,0    
	,0,0,0,0,0,0,0,0    ,0,0,0,0,0,0,0,0    
	,0,0,0,0,0,0,0,0    ,0,0,0,0,0,0,0,0    
	,0,1,2,3,4,5,6,7    ,8,9,0,0,0,0,0,0    
	,0,10,11,12,13,14,15,0    ,0,0,0,0,0,0,0,0    
	,0,0,0,0,0,0,0,0    ,0,0,0,0,0,0,0,0
	,0,10,11,12,13,14,15,0    ,0,0,0,0,0,0,0,0    
	,0,0,0,0,0,0,0,0    ,0,0,0,0,0,0,0,0
	,0,0,0,0,0,0,0,0    ,0,0,0,0,0,0,0,0
	,0,0,0,0,0,0,0,0    ,0,0,0,0,0,0,0,0
	,0,0,0,0,0,0,0,0    ,0,0,0,0,0,0,0,0    
	,0,0,0,0,0,0,0,0    ,0,0,0,0,0,0,0,0    
	,0,0,0,0,0,0,0,0    ,0,0,0,0,0,0,0,0    
	,0,0,0,0,0,0,0,0    ,0,0,0,0,0,0,0,0
	,0,0,0,0,0,0,0,0    ,0,0,0,0,0,0,0,0
	,0,0,0,0,0,0,0,0    ,0,0,0,0,0,0,0,0
};

static const char htbl[256][2] =
{
  {'0','0'}, {'0','1'}, {'0','2'}, {'0','3'}, {'0','4'}, {'0','5'}, {'0','6'}, {'0','7'}, {'0','8'}, {'0','9'}, {'0','a'}, {'0','b'}, {'0','c'}, {'0','d'}, {'0','e'}, {'0','f'}, 
  {'1','0'}, {'1','1'}, {'1','2'}, {'1','3'}, {'1','4'}, {'1','5'}, {'1','6'}, {'1','7'}, {'1','8'}, {'1','9'}, {'1','a'}, {'1','b'}, {'1','c'}, {'1','d'}, {'1','e'}, {'1','f'}, 
  {'2','0'}, {'2','1'}, {'2','2'}, {'2','3'}, {'2','4'}, {'2','5'}, {'2','6'}, {'2','7'}, {'2','8'}, {'2','9'}, {'2','a'}, {'2','b'}, {'2','c'}, {'2','d'}, {'2','e'}, {'2','f'}, 
  {'3','0'}, {'3','1'}, {'3','2'}, {'3','3'}, {'3','4'}, {'3','5'}, {'3','6'}, {'3','7'}, {'3','8'}, {'3','9'}, {'3','a'}, {'3','b'}, {'3','c'}, {'3','d'}, {'3','e'}, {'3','f'}, 
  {'4','0'}, {'4','1'}, {'4','2'}, {'4','3'}, {'4','4'}, {'4','5'}, {'4','6'}, {'4','7'}, {'4','8'}, {'4','9'}, {'4','a'}, {'4','b'}, {'4','c'}, {'4','d'}, {'4','e'}, {'4','f'}, 
  {'5','0'}, {'5','1'}, {'5','2'}, {'5','3'}, {'5','4'}, {'5','5'}, {'5','6'}, {'5','7'}, {'5','8'}, {'5','9'}, {'5','a'}, {'5','b'}, {'5','c'}, {'5','d'}, {'5','e'}, {'5','f'}, 
  {'6','0'}, {'6','1'}, {'6','2'}, {'6','3'}, {'6','4'}, {'6','5'}, {'6','6'}, {'6','7'}, {'6','8'}, {'6','9'}, {'6','a'}, {'6','b'}, {'6','c'}, {'6','d'}, {'6','e'}, {'6','f'}, 
  {'7','0'}, {'7','1'}, {'7','2'}, {'7','3'}, {'7','4'}, {'7','5'}, {'7','6'}, {'7','7'}, {'7','8'}, {'7','9'}, {'7','a'}, {'7','b'}, {'7','c'}, {'7','d'}, {'7','e'}, {'7','f'}, 
  {'8','0'}, {'8','1'}, {'8','2'}, {'8','3'}, {'8','4'}, {'8','5'}, {'8','6'}, {'8','7'}, {'8','8'}, {'8','9'}, {'8','a'}, {'8','b'}, {'8','c'}, {'8','d'}, {'8','e'}, {'8','f'}, 
  {'9','0'}, {'9','1'}, {'9','2'}, {'9','3'}, {'9','4'}, {'9','5'}, {'9','6'}, {'9','7'}, {'9','8'}, {'9','9'}, {'9','a'}, {'9','b'}, {'9','c'}, {'9','d'}, {'9','e'}, {'9','f'}, 
  {'a','0'}, {'a','1'}, {'a','2'}, {'a','3'}, {'a','4'}, {'a','5'}, {'a','6'}, {'a','7'}, {'a','8'}, {'a','9'}, {'a','a'}, {'a','b'}, {'a','c'}, {'a','d'}, {'a','e'}, {'a','f'}, 
  {'b','0'}, {'b','1'}, {'b','2'}, {'b','3'}, {'b','4'}, {'b','5'}, {'b','6'}, {'b','7'}, {'b','8'}, {'b','9'}, {'b','a'}, {'b','b'}, {'b','c'}, {'b','d'}, {'b','e'}, {'b','f'}, 
  {'c','0'}, {'c','1'}, {'c','2'}, {'c','3'}, {'c','4'}, {'c','5'}, {'c','6'}, {'c','7'}, {'c','8'}, {'c','9'}, {'c','a'}, {'c','b'}, {'c','c'}, {'c','d'}, {'c','e'}, {'c','f'}, 
  {'d','0'}, {'d','1'}, {'d','2'}, {'d','3'}, {'d','4'}, {'d','5'}, {'d','6'}, {'d','7'}, {'d','8'}, {'d','9'}, {'d','a'}, {'d','b'}, {'d','c'}, {'d','d'}, {'d','e'}, {'d','f'}, 
  {'e','0'}, {'e','1'}, {'e','2'}, {'e','3'}, {'e','4'}, {'e','5'}, {'e','6'}, {'e','7'}, {'e','8'}, {'e','9'}, {'e','a'}, {'e','b'}, {'e','c'}, {'e','d'}, {'e','e'}, {'e','f'}, 
  {'f','0'}, {'f','1'}, {'f','2'}, {'f','3'}, {'f','4'}, {'f','5'}, {'f','6'}, {'f','7'}, {'f','8'}, {'f','9'}, {'f','a'}, {'f','b'}, {'f','c'}, {'f','d'}, {'f','e'}, {'f','f'}, 
};


namespace zli
{

  std::string trim(const std::string & s)
  {
	int code = 0;
	auto it = s.begin();
	for(; it != s.end(); ++it) {
	  code = (unsigned char)(*it);
	  if (!isspace(code)) {
		break;
	  }
	}
	std::string tleft = s.substr(it - s.begin());
	if (tleft.length() == 0)
	  return tleft;

	const char * data = tleft.data();
	size_t index = tleft.length() - 1;
	while (index != 0) {
	  code = (unsigned char)data[index];
	  if (isspace(code)) {
		--index;
		continue;
	  }
	  break;
	}
	return tleft.substr(0, index+1);
  }

  std::string hexShow(const void * buffer_, size_t len) 
  {
	const char * buffer = static_cast<const char*>(buffer_);
	std::string h;
	std::string p;
	char bh [1024];
	char bp [1024];
	for (size_t oi = 0 ; oi < len ; ++oi) {
	  unsigned char c = buffer[oi];
	  char cs = isprint(c) ? c : '*' ; 
	  sprintf(bh, "%02x ", (unsigned int)(unsigned char)c);
	  sprintf(bp, "%c ", cs);
	  if (oi) {
		if(oi%16 == 0) {
		  h.append("  ");
		  h.append(p);
		  h.append("\n");
		  p.clear();
		} else if (oi % 8 == 0) {
		  h.append(" |  ");
		  p.append("| ");
		}		
	  }
	  h.append(bh);
	  p.append(bp);
	}
	int f = 54 - h.length() % 89;
	h.append(
		"                "
		"                "
		"                "
		"                "
		"                "
		"                "
		, f);
	h.append(p);
	return h;
  }

  std::string hex2str(const std::string & src)
  {
	size_t len = src.length();
	const char * d = src.data();
	return hex2str(d, len);
  }

  std::string hex2str(const void * d_, size_t len)
  {
	const char * d = static_cast<const char*>(d_);
	size_t mask = 1;
	len &= ~mask;
	std::string ret;
	ret.reserve(len / 2);
	for(size_t i = 0 ; i < len ; i += 2) {
	  unsigned char uc0 = static_cast<unsigned char>(d[i]);
	  unsigned char uc1 = static_cast<unsigned char>(d[i+1]);
	  char off = (ctbl[uc0] << 4) + ctbl[uc1];
	  ret.append(&off, 1);
	}
	return ret;
  }

  void hex2str(void * dst, const void * src, size_t len)
  {
	const unsigned char * s = static_cast<const unsigned char*>(src);
	size_t mask = 1;
	len &= ~mask;
	unsigned char uc0, uc1;
	StreamWriter w(dst);
	for(size_t i = 0 ; i < len ; i += 2) {
	  uc0 = s[i];
	  uc1 = s[i+1];
	  w.w((ctbl[uc0] << 4) + ctbl[uc1]);
	}
  }

  void str2hex(void * dst, const void * str, size_t len)
  {
	zli::StreamWriter w(dst);
	const unsigned char * curr = static_cast<const unsigned char *>(str);
	const unsigned char * end = curr + len;
	unsigned char hoff;
	for (; curr < end ; ++curr) {
	  hoff = *curr ;
	  w.w(htbl [hoff][0]);
	  w.w(htbl [hoff][1]);
	}
  }

  std::string str2hex(const void * str, size_t len)
  {
	char buffer[256];
	const size_t pitch = 128;
	size_t off = 0;
	size_t lines = len / pitch;
	size_t lastOff = len % pitch;
	const char * curr = static_cast<const char*>(str);
	std::string ret;
	ret.reserve(len * 2);

	StreamWriter w(buffer);
	unsigned char hoff;
	for (off = 0 ; off < lines; ++off) {
	  for (size_t i = 0 ; i < pitch; ++i) {
		hoff = (unsigned char &)*curr ;
		w.w(htbl [hoff][0]);
		w.w(htbl [hoff][1]);
		++curr;
	  }
	  ret.append(buffer, sizeof(buffer));
	  w.reset();
	}

	for (size_t i = 0 ; i < lastOff; ++i) {
	  hoff = (unsigned char&)*curr ;
	  w.w(htbl [hoff][0]);
	  w.w(htbl [hoff][1]);
	  ++curr;
	}	
	ret.append(buffer, lastOff * 2);
	return ret;
  }

  std::string str2hex(const std::string & src)
  {
	return str2hex(src.data(), src.length());
  }

  void reverse(void * str_, size_t len) 
  {
	if (!len)
	  return ;

	char t;
	char * str = static_cast<char*>(str_);
	char * last = str + len - 1;

	do {
	  t = *str;
	  *str = *last;
	  *last = t;
	} while(++str < --last);
  }

}

void __zli__hex2str(void * dst, const void * str, size_t len)
{
  zli::hex2str(dst, str, len);
}

void __zli__str2hex(void * dst, const void * str, size_t len)
{
  zli::str2hex(dst, str, len);
}

void __zli__reverse(void * str, size_t len)
{
  zli::reverse(str, len);
}
