#include "skeleton/skeleton.hpp"

#include <iostream>

#include <Poco/DigestStream.h>
#include <Poco/MD5Engine.h>

#include <boost/regex.hpp>

namespace skeleton {

std::string get_md5_sum()
{
    Poco::MD5Engine md5;
    Poco::DigestOutputStream ds(md5);
    ds << "abcdefghijklmnopqrstuvwxyz";

    // Arbitrary internal boost use
    boost::regex expr{R"(\b[a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}\b)"};

    return std::string(Poco::DigestEngine::digestToHex(md5.digest()));
}

}  // namespace skeleton
