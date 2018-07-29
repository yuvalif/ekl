#include <string>
#include <string.h>

namespace octave_utils 
{


class Matrix
{
public:
    Matrix() : m_height(0), m_width(0), m_data(nullptr)
    {}

    Matrix(unsigned height, unsigned width) : m_height(height), m_width(width)
    { m_data = new double[height*width]; }

    ~Matrix() 
    { delete[] m_data; }

    Matrix(const Matrix& other) : m_height(other.m_height), m_width(other.m_width)
    { 
        m_data = new double[m_height*m_width];
        memcpy(m_data, other.m_data, m_height*m_width*sizeof(double));
    }

    double operator()(unsigned i, unsigned j) const;
    double& operator()(unsigned i, unsigned j);

    unsigned height() const { return m_height; }
    unsigned width() const { return m_width; }

private:
    const unsigned m_height;
    const unsigned m_width;
    double* m_data;
};

class Matrix3
{
public:
    Matrix3() : m_height(0), m_width(0), m_depth(0), m_data(nullptr)
    {}

    Matrix3(unsigned height, unsigned width, unsigned depth) : m_height(height), m_width(width), m_depth(depth)
    { m_data = new double[height*width*depth]; }

    ~Matrix3() 
    { delete[] m_data; }

    Matrix3(const Matrix3& other) : m_height(other.m_height), m_width(other.m_width), m_depth(other.m_depth)
    {
        m_data = new double[m_height*m_width*m_depth];
        memcpy(m_data, other.m_data, m_height*m_width*m_depth*sizeof(double));
    }

    double operator()(unsigned i, unsigned j, unsigned k) const;
    double& operator()(unsigned i, unsigned j, unsigned k);

    unsigned height() const { return m_height; }
    unsigned width() const { return m_width; }
    unsigned depth() const { return m_depth; }

private:
    const unsigned m_height;
    const unsigned m_width;
    const unsigned m_depth;
    double* m_data;
};

Matrix load(const std::string &file_name);

void save(const Matrix& m, const std::string& file_name);

void print(const Matrix& m);

void print(const Matrix3& m);

Matrix zeros(unsigned height, unsigned width);

Matrix ones(unsigned height, unsigned width);

Matrix3 zeros(unsigned height, unsigned width, unsigned depth);

Matrix3 ones(unsigned height, unsigned width, unsigned depth);

}
