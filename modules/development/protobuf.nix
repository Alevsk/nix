{
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    # Core protobuf tools
    protobuf
    buf
    protoc-gen-go
    protoc-gen-go-grpc
    go
  ];

  # Use home.activation to install Go tools declaratively
  home.activation.installGoProtocTools = lib.hm.dag.entryAfter ["writeBoundary"] ''
    export PATH="${pkgs.go}/bin:$PATH"
    export GOPATH="$HOME/go"
    export GOBIN="$HOME/go/bin"

    # Create GOPATH directories if they don't exist
    mkdir -p "$GOPATH/bin"

    # Install protoc-gen-grpc-gateway if not present
    if [ ! -f "$GOBIN/protoc-gen-grpc-gateway" ]; then
      echo "Installing protoc-gen-grpc-gateway..."
      ${pkgs.go}/bin/go install github.com/grpc-ecosystem/grpc-gateway/v2/protoc-gen-grpc-gateway@v2.19.1
    fi

    # Install protoc-gen-openapiv2 if not present
    if [ ! -f "$GOBIN/protoc-gen-openapiv2" ]; then
      echo "Installing protoc-gen-openapiv2..."
      ${pkgs.go}/bin/go install github.com/grpc-ecosystem/grpc-gateway/v2/protoc-gen-openapiv2@v2.19.1
    fi
  '';

  # Ensure GOPATH/bin is in PATH
  home.sessionPath = ["$HOME/go/bin"];
}
