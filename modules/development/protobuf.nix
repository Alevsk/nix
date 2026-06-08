{pkgs, ...}: {
  home.packages = with pkgs; [
    protobuf
    buf
    protoc-gen-go
    protoc-gen-go-grpc
  ];
}
