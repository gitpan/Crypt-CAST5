# See if we can interoperate with Crypt::CBC
use Test::More;

eval {
  require Crypt::CBC;
  die "Unsupported Crypt::CBC version"
      if $Crypt::CBC::VERSION < 1.22;
};
if ($@) {
  plan skip_all => "Couldn't load Crypt::CBC";
}
else {
  plan tests => 3;
}

my $cbc = Crypt::CBC->new("0123456789abcdef", "CAST5");

my $msg = $cbc->decrypt(pack("H*",
    "52616e646f6d49567878787878787878dfded8538c2ca967426a9c38006d5673"
));
is(unpack("H*",$msg), unpack("H*","foo bar baz"), "decryption");

$msg = "'Twas brillig, and the slithy toves";
my $c = $cbc->encrypt($msg);
is(length($c), 56, "ciphertext length check");
my $d = $cbc->decrypt($c);
is(unpack("H*",$d), unpack("H*",$msg), "encrypt-decrypt");

# end 2cbc.t
