{ fetchgit, mirror }:

{
  qtmqtt = rec {
    version = "5.12.7";
    src = fetchgit {
      url = "${mirror}/qt/qtmqtt.git";
      rev = "v${version}";
      sha256 = "1r1clvp620g6ad90mkfip4si0h15cpy9y65wshply7h49jixc16m";
    };
  };
}
