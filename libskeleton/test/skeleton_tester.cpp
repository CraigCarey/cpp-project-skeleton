#include <gtest/gtest.h>

#include <boost/chrono.hpp>
#include <boost/optional.hpp>

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
    auto md5_gt{"d41d8cd98f00b204e9800998ecf8427e"};

    ASSERT_EQ(*md5, md5_gt);
}

TEST_F(TestSkeleton, TestSkeletonClock)
{
    auto time_point = skeleton::get_sys_clock();

    long tse = time_point.time_since_epoch().count();

    ASSERT_GT(tse, 1592377858188806743);
}

int main(int argc, char **argv)
{
    ::testing::InitGoogleTest(&argc, argv);
    return RUN_ALL_TESTS();
}
