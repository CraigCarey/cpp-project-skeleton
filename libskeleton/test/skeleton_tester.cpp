#include <gtest/gtest.h>

#include "../include/skeleton.hpp"

class TestSkeleton : public ::testing::Test
{
protected:
    void SetUp() override {}

    void TearDown() override {}
};

TEST_F(TestSkeleton, TestSkeletonMD5)
{
    auto md5 = get_md5_sum();
    auto md5_gt{"d41d8cd98f00b204e9800998ecf8427e"};

    ASSERT_EQ(md5, md5_gt);
}

int main(int argc, char **argv)
{
    ::testing::InitGoogleTest(&argc, argv);
    return RUN_ALL_TESTS();
}
