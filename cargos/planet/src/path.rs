use crate::network::*;
use itertools::Itertools;
use std::collections::HashMap;

#[derive(Default, PartialEq, Eq, Hash, Clone)]
pub struct Path {
    edges: Vec<EdgeIndex>,
    origin: NodeIndex,
    destination: NodeIndex,
}

impl Path {
    /// Check nodes are simple path of at least 2 valid consequitive nodes in a network.
    pub fn from_nodes(nodes: Vec<NodeIndex>, network: &ReducedNetwork) -> Option<Self> {
        let iter = nodes.iter().tuple_windows::<(_, _)>();

        let edges: Option<Vec<EdgeIndex>> = iter
            .map(|(from, to)| network.find_edge(*from, *to))
            .collect();

        match edges {
            None => None,
            Some(edges) => (!edges.is_empty()).then_some(Path {
                edges,
                origin: *nodes.first().unwrap(),
                destination: *nodes.last().unwrap(),
            }),
        }
    }

    pub fn origin(&self) -> NodeIndex {
        self.origin
    }

    pub fn destination(&self) -> NodeIndex {
        self.destination
    }

    pub fn edges(&self) -> &Vec<EdgeIndex> {
        &self.edges
    }
}

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
    pub fn new() -> Self {
        PathFlowBundle(HashMap::default())
    }

    pub fn add_path(&mut self, path: Path, flow: f32) {
        self.0
            .entry(path)
            .and_modify(|f| {
                *f += flow;
            })
            .or_insert(flow);
    }

    pub fn clear(&mut self) {
        self.0.clear();
    }

    pub fn scale(&mut self, scale: f32) {
        self.0.values_mut().for_each(|value| *value *= scale);
    }

    pub fn flow_map(&self) -> HashMap<EdgeIndex, f32> {
        let mut map = HashMap::<EdgeIndex, f32>::new();

        for (path, flow) in self.0.iter() {
            for &edge in path.edges.iter() {
                map.entry(edge).and_modify(|f| *f += *flow).or_insert(*flow);
            }
        }

        map
    }
}
