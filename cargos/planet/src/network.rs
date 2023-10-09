use glm::Vec2;
use petgraph::prelude::*;

use crate::path::{Path, PathFlow, PathFlowBundle};

#[derive(Debug)]
pub struct EdgeInfo {
    pub name: String,
    pub lane_count: u16,
    pub capacity: f32,
    pub length: f32,
    pub free_speed: f32,
}

#[derive(Debug)]
pub struct NodeInfo {
    pub name: String,
    pub position: Vec2,
}

type Graph = StableDiGraph<NodeInfo, EdgeInfo, u32>;

/// Abstract network for calculation
/// 
/// It should be 'immutable' after built up.
#[derive(Debug, Default)]
pub struct ReducedNetwork {
    graph: Graph,
}

impl ReducedNetwork {
    pub fn new() -> Self {
        ReducedNetwork {
            graph: Graph::new()
        }
    }

    pub fn add_node(&mut self, info: NodeInfo) -> NodeIndex {
        self.graph.add_node(info)
    }

    pub fn add_edge(&mut self, id_from: NodeIndex, id_to: NodeIndex, info: EdgeInfo) -> Option<EdgeIndex> {
        (
            self.graph.contains_node(id_from)
            & self.graph.contains_node(id_to)
            & !self.graph.contains_edge(id_from, id_to)
        ).then(|| self.graph.add_edge(id_from, id_to, info))
    }

    pub fn debug_dump(&self) -> String {
        format!("{:#?}", self)
    }

    pub fn shortest_path<F>(&self, id_from: NodeIndex, id_to: NodeIndex, edge_cost: F) -> Option<(f32, Path)>
    where F: FnMut(NodeIndex) -> f32,
    {
        unimplemented!("Stub");
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn it_works() {
        let network = ReducedNetwork::new();
        assert!(network.debug_dump().starts_with("ReducedNetwork"));
    }
}