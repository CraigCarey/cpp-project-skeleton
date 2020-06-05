#include <iostream>

#include <gtest/gtest.h>

#include <Poco/DigestStream.h>
#include <Poco/MD5Engine.h>

class TestFixture : public ::testing::Test
{
protected:
    void SetUp() override
    {
        std::cout << "SetUp()\n";
    }

    void TearDown() override
    {
        std::cout << "TearDown()\n";
    }
};

TEST_F(TestFixture, TestPocoMD5)
{
    Poco::MD5Engine md5_engine;
    Poco::DigestOutputStream ds(md5_engine);
    ds << "abcdefghijklmnopqrstuvwxyz";
    ds.close();
    auto md5 = Poco::DigestEngine::digestToHex(md5_engine.digest());

    auto md5_gt{"c3fcd3d76192e4007dfb496cca67e13b"};

    ASSERT_EQ(md5, md5_gt);
}

int main(int argc, char **argv)
{
    ::testing::InitGoogleTest(&argc, argv);
    return RUN_ALL_TESTS();
}
