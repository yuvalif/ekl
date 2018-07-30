#include "octave_utils.h"
#include <string>
#include <fstream>
#include <iostream>
#include <boost/tokenizer.hpp>

namespace octave_utils
{

double Matrix::operator()(unsigned i, unsigned j) const
{
    if (m_data == nullptr || i >= m_height || j >= m_width)
    {
        std::cerr << "invalid access to matrix" << std::endl;
    }
    return m_data[i*m_width + j];
}

double& Matrix::operator()(unsigned i, unsigned j)
{
    if (m_data == nullptr || i >= m_height || j >= m_width)
    {
        std::cerr << "invalid access to matrix" << std::endl;
    }
    return m_data[i*m_width + j];
}

double Matrix3::operator()(unsigned i, unsigned j, unsigned k) const
{
    if (m_data == nullptr || i >= m_height || j >= m_width || k >= m_depth)
    {
        std::cerr << "invalid access to matrix" << std::endl;
    }
    return m_data[(i*m_width + j)*m_height + k];
}

double& Matrix3::operator()(unsigned i, unsigned j, unsigned k)
{
    if (m_data == nullptr || i >= m_height || j >= m_width || k >= m_depth)
    {
        std::cerr << "invalid access to matrix" << std::endl;
    }
    return m_data[(i*m_width + j)*m_height + k];
}

Matrix load(const std::string &file_name)
{
    std::ifstream infile(file_name);
    std::string line;
    Matrix empty;
    // read first line to get the width
    if (!std::getline(infile, line))
    {
        std::cout << "empty" << std::endl;
        return empty;
    }

    unsigned height = 1; // already read one line
    unsigned width = 0;
    {
        boost::tokenizer<> tok(line);
        for(boost::tokenizer<>::iterator it = tok.begin(); it != tok.end(); ++it, ++width);
    }

    std::cout << "width=" << width << std::endl;
    // read all lines to get the height
    while (std::getline(infile, line))
    {
        ++height;
    }
    std::cout << "height=" << height << std::endl;
    // go back to beggining of file
    infile.seekg(0, infile.beg);

    // read the file again and fill the matrix
    Matrix m(height, width);
    unsigned i = 0;
    while (std::getline(infile, line))
    {
        std::cout << line << std::endl;
        unsigned j = 0;
        boost::tokenizer<> tok(line);
        for(boost::tokenizer<>::iterator it = tok.begin(); it != tok.end(); ++it)
        {
            m(i,j) = std::stof(*it);
            ++j;
        }
        ++i;
    }
    return m;
}

void print(const Matrix& m)
{
    for (auto i = 0U; i < m.height(); ++i)
    {
        for (auto j = 0U; j < m.width(); ++j)
        {
            std::cout << m(i,j) << " ";
        }
        std::cout << std::endl;
    }
}

void print(const Matrix3& m)
{
    for (auto k = 0U; k < m.depth(); ++k)
    {
        std::cout << k << std::endl;
        for (auto i = 0U; i < m.height(); ++i)
        {
            for (auto j = 0U; j < m.width(); ++j)
            {
                std::cout << m(i,j,k) << " ";
            }
            std::cout << std::endl;
        }
    }
}

template<int VALUE>
Matrix same_value(unsigned height, unsigned width)
{
    Matrix m(height,width);
    for (auto i = 0U; i < height; ++i)
    {
        for (auto j = 0U; j < width; ++j)
        {
            m(i,j) = static_cast<double>(VALUE);
        }
    }

    return m;
}

template<int VALUE>
Matrix3 same_value(unsigned height, unsigned width, unsigned depth)
{
    Matrix3 m(height, width, depth);
    for (auto i = 0U; i < height; ++i)
    {
        for (auto j = 0U; j < width; ++j)
        {
            for (auto k = 0U; k < width; ++k)
            {
                m(i,j,k) = static_cast<double>(VALUE);
            }
        }
    }

    return m;
}

Matrix zeros(unsigned height, unsigned width)
{
    return same_value<0>(height,width);
}

Matrix ones(unsigned height, unsigned width)
{
    return same_value<1>(height,width);
}

Matrix3 zeros(unsigned height, unsigned width, unsigned depth)
{
    return same_value<0>(height,width,depth);
}

Matrix3 ones(unsigned height, unsigned width, unsigned depth)
{
    return same_value<1>(height,width,depth);
}
}

