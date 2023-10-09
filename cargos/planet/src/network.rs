use glm::Vec2;
use petgraph::prelude as petgraph;

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

type Graph = petgraph::StableDiGraph<NodeInfo, EdgeInfo, u32>;
pub type NodeIndex = petgraph::NodeIndex<u32>;
pub type EdgeIndex = petgraph::EdgeIndex<u32>;

/// Abstract network for calculation
///
/// - It should be 'immutable' after built up. So there are only 'add' methods
///   and no 'remove' methods for nodes and edges.
/// - It forbids parallel links and self links.
///
#[derive(Debug, Default)]
pub struct ReducedNetwork {
    graph: Graph,
}

impl ReducedNetwork {
    pub fn new() -> Self {
        ReducedNetwork {
            graph: Graph::new(),
        }
    }

    pub fn add_node(&mut self, info: NodeInfo) -> NodeIndex {
        self.graph.add_node(info)
    }

    pub fn add_edge(
        &mut self,
        node_from: NodeIndex,
        node_to: NodeIndex,
        info: EdgeInfo,
    ) -> Option<EdgeIndex> {
        (self.graph.contains_node(node_from)
            & self.graph.contains_node(node_to)
            & !self.graph.contains_edge(node_from, node_to))
        .then(|| self.graph.add_edge(node_from, node_to, info))
    }

    pub fn find_edge(&self, node_from: NodeIndex, node_to: NodeIndex) -> Option<EdgeIndex> {
        self.graph.find_edge(node_from, node_to)
    }

    pub fn debug_dump(&self) -> String {
        format!("{:#?}", self)
    }

    pub fn shortest_path<F>(
        &self,
        node_from: NodeIndex,
        node_to: NodeIndex,
        edge_cost: F,
    ) -> Option<(f32, Path)>
    where
        F: FnMut(NodeIndex) -> f32,
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
