use std::collections::HashMap;
use petgraph::prelude::*;

pub struct Path(Vec<NodeIndex<u32>>);

pub struct PathFlow(Path, f32);

pub struct PathFlowBundle(HashMap<Path, f32>);
