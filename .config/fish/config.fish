set -gx DOTNET_ROOT /home/kyacine/.dotnet
set -gx PATH $PATH /home/kyacine/.dotnet /home/kyacine/.dotnet/tools
if status is-interactive
# Commands to run in interactive sessions can go here
fastfetch
end
