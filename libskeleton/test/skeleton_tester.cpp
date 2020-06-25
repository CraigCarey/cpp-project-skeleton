#include <gtest/gtest.h>

#include <boost/chrono.hpp>
#include <boost/optional.hpp>

#include <opencv2/opencv.hpp>

#include "skeleton/skeleton.hpp"

class TestSkeleton : public ::testing::Test
{
protected:
    void SetUp() override {}

    void TearDown() override {}
};

TEST_F(TestSkeleton, TestSkeletonMD5)
{
    boost::optional<std::string> md5 = skeleton::get_md5_sum();
    auto md5_gt{"c3fcd3d76192e4007dfb496cca67e13b"};

    ASSERT_EQ(*md5, md5_gt);
}

TEST_F(TestSkeleton, TestSkeletonClock)
{
    auto time_point = skeleton::get_sys_clock();

    int64_t tse = time_point.time_since_epoch().count();

    // ASSERT_GT(tse, 945109762); // TODO: doesn't work in Windows
}

TEST_F(TestSkeleton, TestGetCVMat)
{
    cv::Mat gt(500, 1000, CV_8UC1, cv::Scalar(70));
    cv::Mat img = skeleton::get_cv_mat();
    bool img_match = (sum(gt != img) == cv::Scalar(0, 0, 0, 0));
    ASSERT_TRUE(img_match);
}

int main(int argc, char **argv)
{
    ::testing::InitGoogleTest(&argc, argv);
    return RUN_ALL_TESTS();
}
