# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include passec
class passec (
  Array $registry_values,
  String $domain_name,
) {

  contain passec::install
  contain passec::config

  Class['::passec::install']
  -> Class['::passec::config']

}
