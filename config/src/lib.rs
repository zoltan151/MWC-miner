// Copyright 2020 The MWC Developers
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

//! Crate wrapping up mining configuration file

#![deny(non_upper_case_globals)]
#![deny(non_camel_case_types)]
#![allow(non_snake_case)]
#![allow(unused_mut)]
#![warn(missing_docs)]

extern crate serde;
#[macro_use]
extern crate serde_derive;
extern crate toml;

#[macro_use]
extern crate slog;

extern crate cuckoo_miner as cuckoo;
extern crate MWC_miner_util as util;

mod config;
mod types;

pub use config::read_configs;
pub use types::{ConfigError, ConfigMembers, GlobalConfig, MWCMinerPluginConfig, MinerConfig};
