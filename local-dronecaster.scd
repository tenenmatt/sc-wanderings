(
~dronePath = Platform.userHomeDir ++ "/Documents/code/dronecaster/engine/drones";
~caster = Dronecaster.new(Server.default, ~dronePath);
~caster.socket.setFadeTime(2.0);
~caster.setAmp(0.4);
~caster.setHz(220);
~caster.start("Fieldsteel");
)

