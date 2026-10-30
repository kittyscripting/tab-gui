pub const SystemTime = extern struct {
    unix_secs: u64,
    monotonic_secs: u64,
};

pub fn systemTime() SystemTime {
    return undefined;
}
