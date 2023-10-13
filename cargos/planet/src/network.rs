use std::collections::HashMap;

use crate::path::{Path, PathFlow, PathFlowBundle};
use glm::Vec2;
use itertools::Itertools;
use petgraph::algo::astar;
use petgraph::prelude as pet;
use petgraph::visit::EdgeRef;

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

type Graph = pet::StableDiGraph<NodeInfo, EdgeInfo, u32>;
pub type NodeIndex = pet::NodeIndex<u32>;
pub type EdgeIndex = pet::EdgeIndex<u32>;

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

    pub fn ensure_path(&self, origin: NodeIndex, dest: NodeIndex) -> bool {
        let path = self.shortest_path(origin, dest, |_edge| 1.0f32);
        path.is_some()
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
        F: Fn(EdgeIndex) -> f32,
    {
        let estimate_cost = |_node: NodeIndex| 0.0f32;

        astar(
            &self.graph,
            node_from,
            |node: NodeIndex| node == node_to,
            |edge| edge_cost(edge.id()),
            estimate_cost,
        )
        .map(|(cost, nodes)| (cost, Path::from_nodes(nodes, self).unwrap()))
    }

    pub fn assignment_flow(&self, od: &OD) -> PathFlowBundle {
        let mut bundle = PathFlowBundle::new();
        for (o, d, flow) in od.iter() {
            self.shortest_path(o, d, |_edge| 1.0f32)
            .and_then(|(_cost, path)| Some(bundle.add_path(path, flow) ));
        }
        bundle
    }
}

#[derive(Debug)]
pub struct OD {
    os: Vec<NodeIndex>,
    ds: Vec<NodeIndex>,
    flows: HashMap<(NodeIndex, NodeIndex), f32>,
}

impl OD {
    pub fn new(os: &[NodeIndex], ds: &[NodeIndex], network: &ReducedNetwork) -> Option<Self> {
        os.iter()
            .cartesian_product(ds.iter())
            .all(|(o, d)| network.ensure_path(*o, *d))
            .then_some(OD {
                os: os.into(),
                ds: ds.into(),
                flows: HashMap::new(),
            })
    }

    pub fn set_flow(&mut self, o: NodeIndex, d: NodeIndex, flow: f32) {
        self.flows.insert((o, d), flow);
    }

    pub fn get_flow(&self, o: NodeIndex, d: NodeIndex) -> Option<f32> {
        self.flows.get(&(o, d)).copied()
    }

    pub fn iter(&self) -> impl Iterator<Item = (NodeIndex, NodeIndex, f32)> + '_ {
        self.os
            .iter()
            .cartesian_product(self.ds.iter())
            .filter_map(|(&o, &d)| self.flows.get(&(o, d)).map(|flow| (o, d, *flow)))
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
