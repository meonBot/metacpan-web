use strict;
use warnings;
use lib 't/lib';

use MetaCPAN::Web::Test qw( app GET test_cache_headers test_psgi );
use Test::More;

my @tests = (
    {
        url => '/about'
    },
    {
        url => '/about/contributing',
    },
    {
        url => '/about/sponsors/past',
    },
);

my @redirect_tests = (
    {
        url      => '/about/development',
        redirect => '/about/contributing',
    },
    {
        url      => '/about/missing_modules',
        redirect => '/about/faq#why-is-a-specific-module-not-found',
    },
    {
        url      => '/about/meta_hack',
        redirect => '/about/sponsors',
    },
);

test_psgi app, sub {
    my $cb = shift;

    foreach my $test (@tests) {
        ok( my $res = $cb->( GET $test->{url} ), 'GET ' . $test->{url} );
        is( $res->code, 200, 'code 200' );
        test_cache_headers(
            $res,
            {
                cache_control => 'max-age=86400',
                surrogate_key =>
                    'ABOUT STATIC content_type=text/html content_type=text',
                surrogate_control =>
                    'max-age=31556952, stale-while-revalidate=86400, stale-if-error=2592000',
            }
        );
    }

    foreach my $test (@redirect_tests) {
        ok( my $res = $cb->( GET $test->{url} ), 'GET ' . $test->{url} );
        is( $res->code, 301, 'code 301 for ' . $test->{url} );
        like( $res->header('Location'),
            qr/\Q$test->{redirect}\E$/, 'redirects to ' . $test->{redirect} );
    }

};

done_testing;
