package FormValidator::Simple::ProfileManager::YAML;
use strict;

use vars qw($VERSION);
$VERSION = '0.01';

sub new {
    my $class = shift;
    my $self = bless {}, $class;
    $self->init(@_);
    $self;
}

sub init {
    my ($self, $options) = @_;
    my $yaml = $options->{profile};
    my $loader = $options->{loader} || 'YAML';
    if ( $loader eq 'YAML::Syck') {
        require YAML::Syck;
        $self->{_profile} = YAML::Syck::LoadFile($yaml);
    } elsif ( $loader eq 'YAML' ) {
        require YAML;
        $self->{_profile} = YAML::LoadFile($yaml);
    } else {
        die "Don't know loader $loader";
    }

}

sub get_profile {
    my ($self, @paths) = @_;
    return $self->_get_profile_recursive($self->{_profile}, @paths);
}

sub _get_profile_recursive {
    my ($self, $profile, @paths) = @_;
    if ( @paths ) {
        $profile = $profile->{shift @paths};
        return $profile ? $self->_get_profile($profile, @paths) : undef;
    } else {
        return $profile;
    }
}

1;
__END__

=head1 NAME

FormValidator::Simple::ProfileManager::YAML - YAML profile manager for FormValidator::Simple

=head1 SYNOPSIS

  use FormValidator::Simple;
  use FormValidator::Simple::ProfileManager::YAML;

  my $manager = FormValidator::Simple::ProfileManager::YAML->new(
    profile => '/path/to/profile.yml',
  );

  my $profile = $manager->get_profile(@groups);

  my $result = FormValidator::Simple->check($q, $profile);


  # Default YAML loader is 'YAML'.
  # If you want to use 'YAML::Syck' as loader, pass 'loader' to constructor as below.
  my $manager = FormValidator::Simple::ProfileManager::YAML->new(
    profile     => '/path/to/profile.yml',
    loader =>'YAML::Syck',
  );

  # sample yaml profile

  group1 :
      - name
      - [ [NOT_BLANK] ]
      - email
      - [ [NOT_BLANK], [EMAIL_LOOSE] ]
      - tel
      - [ [NOT_BLANK], [NUMBER_PHONE_JP] ]
      - content
      - [ [NOT_BLANK] ]

  group2 :
     subgroup1 :
         - userid
         - [ [NOT_BLANK]]
         - password
         - [ [NOT_BLANK]]
         - name
         - [ [NOT_BLANK] ]
         - email
         - [ [NOT_BLANK], [EMAIL_LOOSE] ]

     subgroup2 :
         - tel
         - [ [NOT_BLANK], [NUMBER_PHONE_JP] ]
         - { zip : [zip1, zip2] }
         - [ [ZIP_JP] ]
         - address
         - [ [NOT_BLANK] ]


  # get profile 'group1'
  $profile = $manager->get_profile('group1');

  # get profile 'subgroup2'
  $profile = $manager->get_profile( 'group2', 'subgroup2' );


=head1 DESCRIPTION

FormValidator::Simple::ProfileManager::YAML is YAML profile manager for FormValidator::Simple.

=head1 AUTHOR

Yasuhiro Horiuchi E<lt>yasuhiro@hori-uchi.comE<gt>

=cut
