fn main() {
    // Generating C++ files
    let _ = cxx_build::bridge("src/lib.rs");
}