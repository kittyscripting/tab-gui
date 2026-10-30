const Actor = @import("actor.zig").Actor;
const Prop = @import("prop.zig").Prop;
const LocalActor = @import("local_actor.zig").LocalActor;

pub fn actors() []Actor {
    return undefined;
}

pub fn props() []Prop {
    return undefined;
}

pub fn localActor() ?*LocalActor {
    return undefined;
}

pub fn inSimulation() bool {
    return undefined;
}
