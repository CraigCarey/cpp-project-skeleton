#include "skeleton/skeleton.hpp"

#include <iostream>

#include "Poco/DigestStream.h"
#include "Poco/MD5Engine.h"

namespace skeleton {

std::string get_md5_sum()
{
    Poco::MD5Engine md5;
    Poco::DigestOutputStream ds(md5);
    ds << "abcdefghijklmnopqrstuvwxyz";

    return std::string(Poco::DigestEngine::digestToHex(md5.digest()));
}

}  // namespace skeleton
