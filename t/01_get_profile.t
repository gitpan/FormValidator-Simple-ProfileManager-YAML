use strict;
use Test::More 'no_plan';

use FormValidator::Simple::ProfileManager::YAML;
use Data::Dumper;

my @Test = (
    ['group1'],
    ['group2', 'subgroup1' ],
    ['group2', 'subgroup2' ],
);

my $manager = FormValidator::Simple::ProfileManager::YAML->new('t/test.yml');

for (@Test) {
    my @group = @$_;
    my $profile = $manager->get_profile(@group);
#    warn Dumper($profile);
    ok $profile;
    is (ref $profile, 'ARRAY');
}

