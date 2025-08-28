{ pkgs, lib, ... }:

let
  # Custom package for protoc-gen-grpc-gateway
  protoc-gen-grpc-gateway = pkgs.buildGoModule rec {
    pname = "protoc-gen-grpc-gateway";
    version = "2.19.1";

    src = pkgs.fetchFromGitHub {
      owner = "grpc-ecosystem";
      repo = "grpc-gateway";
      rev = "v${version}";
      sha256 = "sha256-4bXHImUWdPCxgNwkxqD2aPuEZhPYl9mBsZU7F8rw6Qs=";
    };

    vendorHash = "sha256-R8b+CmYNRqDOTLr3oBaTWVlzK5sOCGYlZDg8eTjWZf4=";

    subPackages = [ "protoc-gen-grpc-gateway" ];

    meta = with lib; {
      description = "gRPC to JSON proxy generator";
      homepage = "https://github.com/grpc-ecosystem/grpc-gateway";
      license = licenses.bsd3;
      maintainers = with maintainers; [ ];
    };
  };

  # Custom package for protoc-gen-openapiv2
  protoc-gen-openapiv2 = pkgs.buildGoModule rec {
    pname = "protoc-gen-openapiv2";
    version = "2.19.1";

    src = pkgs.fetchFromGitHub {
      owner = "grpc-ecosystem";
      repo = "grpc-gateway";
      rev = "v${version}";
      sha256 = lib.fakeSha256;
    };

    vendorHash = lib.fakeSha256;

    subPackages = [ "protoc-gen-openapiv2" ];

    meta = with lib; {
      description = "OpenAPI v2 generator for gRPC";
      homepage = "https://github.com/grpc-ecosystem/grpc-gateway";
      license = licenses.bsd3;
      maintainers = with maintainers; [ ];
    };
  };
in
{
  home.packages = with pkgs; [
    # Core protobuf tools
    protobuf
    buf
    protoc-gen-go
    protoc-gen-go-grpc
    go
    
    # Custom Go protoc plugins
    protoc-gen-grpc-gateway
    protoc-gen-openapiv2
  ];
}
