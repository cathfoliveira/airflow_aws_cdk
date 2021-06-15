import json
import pytest

# fixture certifica que rode a função somente uma vez, todos os testes a partir daí serão feitos em cima de uma mesma estrutura
@pytest.fixture()
def policies_resources_fixture(template_fixture):
    for resource_name, resource in template_fixture["Resources"].items():
        if resource["Type"] in ["AWS::IAM::Policy", "AWS::IAM::ManagedPolicy"]:
            yield resource


# Executa o mesmo teste várias vezes com nomes diferentes, parâmetros para o teste. Testando se o recurso está no template.
@pytest.mark.parametrize(
    "resource_name, expected",
    [
        ("test-airflow-ecs-task-role", True),
        ("test-airflow-ecs-task-policy", True),
        ("test-airflow-ecs-log-group", True),
        ("test-airflow-vpc", True),
        ("test-airflow-fernet-key-parameter", True),
        ("non-existent-resource", False),
    ],
)
def test_resource_in_template(resource_name, expected, template_fixture):
    assert (resource_name in json.dumps(template_fixture)) == expected


def test_if_actions_in_policies_are_open(policies_resources_fixture):
    """
    Will
    """
    for statement in policies_resources_fixture["Properties"]["PolicyDocument"][
        "Statement"
    ]:
        if statement["Action"] == "*":
            raise AssertionError(
                f"The following policy contains a '*' "
                f"action, please revise and specify actions one by one. \n"
                f"{policies_resources_fixture}"
            )
