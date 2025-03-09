const std = @import("std");

const lapack = struct {
    const lapack_int = c_int;

    // ---------------------------------------------------------------------------- //
    //lapack_int LAPACKE_dgesv( int matrix_layout, lapack_int n, lapack_int nrhs,
    //                          double* a, lapack_int lda, lapack_int* ipiv,
    //                          double* b, lapack_int ldb );
    // ---------------------------------------------------------------------------- //
    extern fn LAPACKE_dgesv(
        layout: c_int,
        n: lapack_int,
        nrhs: lapack_int,
        A: *f64,
        lda: lapack_int,
        ipiv: *lapack_int,
        B: *f64,
        ldb: lapack_int,
    ) lapack_int;

    const dgesv = LAPACKE_dgesv;
};

// Example from:
// https://www.intel.com/content/www/us/en/docs/onemkl/code-samples-lapack/2025-0/lapacke-dgesv-example-c-column.html
const MatrixLayout = enum(c_int) {
    ROW_MAJOR = 101,
    COL_MAJOR = 102,
};

pub fn main() !void {
    const n = 5;
    const nrhs = 3;
    const lda = n;
    const ldb = n;

    // zig fmt: off
    var a = [n*lda]f64 {
            6.80, -2.11,  5.66,  5.97,  8.23,
           -6.05, -3.30,  5.36, -4.44,  1.08,
           -0.45,  2.58, -2.70,  0.27,  9.04,
            8.32,  2.71,  4.35, -7.17,  2.14,
           -9.67, -5.14, -7.26,  6.08, -6.87
    };
    var b = [nrhs*ldb]f64 {
            4.02,  6.19, -8.22, -7.57, -3.03,
           -1.56,  4.00, -8.67,  1.75,  2.86,
            9.81, -4.09, -4.57, -8.61,  8.99
    };
    var ipiv = [n]lapack.lapack_int { 0, 0, 0, 0, 0 };
    // zig fmt: on

    const a_ptr: *f64 = @ptrCast(&a);
    const b_ptr: *f64 = @ptrCast(&b);
    const ipiv_ptr: *lapack.lapack_int = @ptrCast(&ipiv);

    const info = lapack.dgesv(
        102,
        n,
        nrhs,
        a_ptr,
        lda,
        ipiv_ptr,
        b_ptr,
        ldb,
    );

    std.debug.print("Solution:\n{any}\n-----------------\n", .{b});
    std.debug.print("returned value: {}\n", .{info});
}
