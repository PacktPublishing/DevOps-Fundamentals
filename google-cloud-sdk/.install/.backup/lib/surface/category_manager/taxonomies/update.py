# Copyright 2018 Google Inc. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
"""Category manager taxonomies update."""

from __future__ import absolute_import
from __future__ import division
from __future__ import print_function
from googlecloudsdk.api_lib.category_manager import taxonomies
from googlecloudsdk.calliope import base
from googlecloudsdk.command_lib.category_manager import flags
from googlecloudsdk.core import properties
from googlecloudsdk.core import resources


class Update(base.Command):
  """Update the description of a taxonomy."""

  @staticmethod
  def Args(parser):
    """Register flags for this command."""
    flags.AddDescriptionFlag(parser)
    flags.AddTaxonomyResourceArg(parser, required=False)

  def Run(self, args):
    """This is what gets called when the user runs this command.

    Args:
      args: an argparse namespace. All the arguments that were provided to this
      command invocation.

    Returns:
      Status of command execution.
    """
    taxonomy_resource = resources.REGISTRY.Create(
        collection='categorymanager.projects.taxonomies',
        projectsId=properties.VALUES.core.project.GetOrFail(),
        taxonomiesId=args.taxonomy)
    description = args.description
    return taxonomies.UpdateTaxonomy(taxonomy_resource, description)
