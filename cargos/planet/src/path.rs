use petgraph::prelude::*;
use std::collections::HashMap;

#[derive(Default, PartialEq, Eq, Hash, Clone)]
pub struct Path(Vec<NodeIndex<u32>>);

pub struct PathFlow {
    pub path: Path,
    pub flow: f32,
}

impl PathFlow {
    pub fn new(path: Path, flow: f32) -> Self {
        PathFlow { path, flow }
    }
}

#[derive(Default)]
pub struct PathFlowBundle(HashMap<Path, f32>);

impl PathFlowBundle {
    fn add_flow(&mut self, path: Path, flow: f32) {
        self.0.entry(path);
    }
}
