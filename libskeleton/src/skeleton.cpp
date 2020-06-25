#include "skeleton/skeleton.hpp"

#include <iostream>

#include <Poco/DigestStream.h>
#include <Poco/MD5Engine.h>

namespace skeleton {

boost::optional<std::string> get_md5_sum()
{
    Poco::MD5Engine md5engine;
    Poco::DigestOutputStream ds(md5engine);
    ds << "abcdefghijklmnopqrstuvwxyz";
    ds.close();
    std::string md5sum = Poco::DigestEngine::digestToHex(md5engine.digest());
    return md5sum;
}

boost::chrono::system_clock::time_point get_sys_clock()
{
    return boost::chrono::system_clock::now();
}

cv::Mat get_cv_mat()
{
    cv::Mat img(500, 1000, CV_8UC1, cv::Scalar(70));
    return img;
}

}  // namespace skeleton
